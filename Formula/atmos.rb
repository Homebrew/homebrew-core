class Atmos < Formula
  desc "Universal Tool for DevOps and Cloud Automation"
  homepage "https://github.com/cloudposse/atmos"
  url "https://github.com/cloudposse/atmos/archive/v1.15.0.tar.gz"
  sha256 "b38595057f0db4535078fe7b2f713b92ec8e07b158ff25e88c4f997a81d88eb5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "49fa248409f37539e10709d1d89babbe1f59e911ab92b19ae8fc43a0c70cf9d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "906e3e46d7aed451b7f01ff9a6a48563460c02dcd24c76451abd2bed44c42099"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "27daa3419a45b32c6444501d1fda74e7e7bc3cc14aeee4e70c12a07a3095ea28"
    sha256 cellar: :any_skip_relocation, ventura:        "b86665eca52d88f8119d55406d943945ee73e3f731435de8753393a067fa2176"
    sha256 cellar: :any_skip_relocation, monterey:       "d22320b5ad479f19a746d03d0643845f4e74a5af798ee76fdebed1d24834e506"
    sha256 cellar: :any_skip_relocation, big_sur:        "1da49e0428dc87bdfef2ff1c1e07efa2ad8bc3df252c8440d085e839089136a7"
    sha256 cellar: :any_skip_relocation, catalina:       "f92a9c8bcdacf7d376e47e921534d02e877b2fe89eb2334401284ef4225accfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b98b5c9c67098dad39f1c2a83ba57917f43ba545358b06d0d8569298404d4806"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X 'github.com/cloudposse/atmos/cmd.Version=#{version}'")

    generate_completions_from_executable(bin/"atmos", "completion")
  end

  test do
    # create basic atmos.yaml
    (testpath/"atmos.yaml").write <<~EOT
      components:
        terraform:
          base_path: "./components/terraform"
          apply_auto_approve: false
          deploy_run_init: true
          auto_generate_backend_file: false
        helmfile:
          base_path: "./components/helmfile"
          kubeconfig_path: "/dev/shm"
          helm_aws_profile_pattern: "{namespace}-{tenant}-gbl-{stage}-helm"
          cluster_name_pattern: "{namespace}-{tenant}-{environment}-{stage}-eks-cluster"
      stacks:
        base_path: "./stacks"
        included_paths:
          - "**/*"
        excluded_paths:
          - "globals/**/*"
          - "catalog/**/*"
          - "**/*globals*"
        name_pattern: "{tenant}-{environment}-{stage}"
      logs:
        verbose: false
        colors: true
    EOT

    # create scaffold
    mkdir_p testpath/"stacks"
    mkdir_p testpath/"components/terraform/top-level-component1"
    (testpath/"stacks/tenant1-ue2-dev.yaml").write <<~EOT
      terraform:
        backend_type: s3 # s3, remote, vault, static, etc.
        backend:
          s3:
            encrypt: true
            bucket: "eg-ue2-root-tfstate"
            key: "terraform.tfstate"
            dynamodb_table: "eg-ue2-root-tfstate-lock"
            acl: "bucket-owner-full-control"
            region: "us-east-2"
            role_arn: null
          remote:
          vault:

      vars:
        tenant: tenant1
        region: us-east-2
        environment: ue2
        stage: dev

      components:
        terraform:
          top-level-component1: {}
    EOT

    # create expected file
    (testpath/"backend.tf.json").write <<~EOT
      {
        "terraform": {
          "backend": {
            "s3": {
              "workspace_key_prefix": "top-level-component1",
              "acl": "bucket-owner-full-control",
              "bucket": "eg-ue2-root-tfstate",
              "dynamodb_table": "eg-ue2-root-tfstate-lock",
              "encrypt": true,
              "key": "terraform.tfstate",
              "region": "us-east-2",
              "role_arn": null
            }
          }
        }
      }
    EOT

    system bin/"atmos", "terraform", "generate", "backend", "top-level-component1", "--stack", "tenant1-ue2-dev"
    actual_json = JSON.parse(File.read(testpath/"components/terraform/top-level-component1/backend.tf.json"))
    expected_json = JSON.parse(File.read(testpath/"backend.tf.json"))
    assert_equal expected_json["terraform"].to_set, actual_json["terraform"].to_set
  end
end
