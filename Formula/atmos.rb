class Atmos < Formula
  desc "Universal Tool for DevOps and Cloud Automation"
  homepage "https://github.com/cloudposse/atmos"
  url "https://github.com/cloudposse/atmos/archive/v1.32.0.tar.gz"
  sha256 "417d50d47e43d4d9a6ebe4b530e95feb6cc2494fc8b4b606450fbebf5939dd0a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74fe9eae0667c6da7892a5ce5e0ce766be3107b642cc58896e6fdb36cf33153e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74fe9eae0667c6da7892a5ce5e0ce766be3107b642cc58896e6fdb36cf33153e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "74fe9eae0667c6da7892a5ce5e0ce766be3107b642cc58896e6fdb36cf33153e"
    sha256 cellar: :any_skip_relocation, ventura:        "e2701d8e2df5dca7bcdf3e7cc7db4cae3909afd1f7550803e859a3e5bef37e8b"
    sha256 cellar: :any_skip_relocation, monterey:       "e2701d8e2df5dca7bcdf3e7cc7db4cae3909afd1f7550803e859a3e5bef37e8b"
    sha256 cellar: :any_skip_relocation, big_sur:        "e2701d8e2df5dca7bcdf3e7cc7db4cae3909afd1f7550803e859a3e5bef37e8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4174a1f838d9a8c3b195ab7e08165c58c7adfcf8b864ef1d8cce622ef37f86c"
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
