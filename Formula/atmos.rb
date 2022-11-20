class Atmos < Formula
  desc "Universal Tool for DevOps and Cloud Automation"
  homepage "https://github.com/cloudposse/atmos"
  url "https://github.com/cloudposse/atmos/archive/v1.14.0.tar.gz"
  sha256 "35f8d066454bb39ea7a18924ff57eec699658b96cf8f1e70992b9e8f4539d732"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1611c29517eefef7148fd34ac48e89c4ef54de55aeeb4a3e08e71422a8d1672e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2e7f9245c6726e358c14e446af13e3ae1a8f13e15e069e5d94b25edaab626c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "20d692cf4f226a817be9ec1897e17b0bc467a5983fb35b3e5d382667d79a258e"
    sha256 cellar: :any_skip_relocation, ventura:        "242efd246b8a7754aaf368ce10f8343ac602e015b3c9ca642eef73b36c73da91"
    sha256 cellar: :any_skip_relocation, monterey:       "618556495e249bd4338ea7a96a598d40b947dd4a4cca9a647897f6477f67ca5a"
    sha256 cellar: :any_skip_relocation, big_sur:        "b13689b768b4979feb13f3e9e5eb574d658a79513767f0b9c20f6a9fdb27b28d"
    sha256 cellar: :any_skip_relocation, catalina:       "04e47944be2c99fc26cf00ec1828d5681fb4ee7ae03afebd11045e38b735ab41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b90e0ab2cb8962ee0fd8b31b3a239e7731a9ea6523384592b148fcd6f500a0f5"
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
