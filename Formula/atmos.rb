class Atmos < Formula
  desc "Universal Tool for DevOps and Cloud Automation"
  homepage "https://github.com/cloudposse/atmos"
  url "https://github.com/cloudposse/atmos/archive/v1.4.10.tar.gz"
  sha256 "9a9038021f4fe2a7164ea56ed05f6d8435f79d75a1744e7c8f1de2ec7c98ecd6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3cdff684fe6c2ee51c5a11eb70fb3075b0033c46f7b8fbe3f9fa21adf75d9007"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "492ed7ace06cb492398b1261ce910ed7aff9350a42b1634cf805664d91297ebb"
    sha256 cellar: :any_skip_relocation, monterey:       "b36303b3c9e072e2e4850f59677ba17c149f81478c8c670000cb0b37d325a2e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "38b45e23287d9775d37ead1e1aabcec09a54a1d985ae679b08b60d5384b13c9c"
    sha256 cellar: :any_skip_relocation, catalina:       "2d68bda23b2c85c541eceaeb11faaa1a121656df0030047ba56219cbbd92a37b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "677d26fb610911e3c030fcb0be12cce226816ae5124d54a3d715a0ce902c37d1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X 'github.com/cloudposse/atmos/cmd.Version=#{version}'")
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
