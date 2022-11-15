class Atmos < Formula
  desc "Universal Tool for DevOps and Cloud Automation"
  homepage "https://github.com/cloudposse/atmos"
  url "https://github.com/cloudposse/atmos/archive/v1.13.3.tar.gz"
  sha256 "90722aca5b851d90bcc2ef94688b7685832b98e17047114dd839047d3199e697"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ebf254042916251cc7f535d671190e3c130809ec31026981aa5ebd1c892dcb84"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7bddbe9380aee5f3ee4b1f89de89671701a82f6ba94513a4474330bbb03de1dd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9032a22761a3aeea6accc3f588db782aab42ff00f680273e5d9f031c3065cdea"
    sha256 cellar: :any_skip_relocation, monterey:       "9b300d4a16934a392a4ab70787fffc0219c8e8ddb74d0f5f435edce1e94809b7"
    sha256 cellar: :any_skip_relocation, big_sur:        "2199f1a511e0b90a63484df4b5e9bef3d83aa3d0ecae8e90d8d6d5515b652ec4"
    sha256 cellar: :any_skip_relocation, catalina:       "35d9bd5fdf43219412050ccda8aade8b67f7e927563d4651af4a85e6fd41677c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ffd7870f32492f3dfbbde386be565e34ce07271c8b9e048624c277af8db65e3"
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
