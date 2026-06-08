class EcsDeploy < Formula
  include Language::Python::Virtualenv

  desc "CLI tool to simplify Amazon ECS deployments, rollbacks & scaling"
  homepage "https://github.com/fabfuel/ecs-deploy"
  url "https://files.pythonhosted.org/packages/99/c8/603b05f78f4d53ffc052be13144bc755410621776a996acf59999f96f3a8/ecs_deploy-1.16.0.tar.gz"
  sha256 "bb63b84ae61f4f086d4cb9272b869c5b0ae031545120dc4c56454dcc09d29cac"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "85f784b6db86fe7f4674c8984d837e9e72ad3704ffcf1c9a52c7b9c837d289f1"
  end

  depends_on "certifi"
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"ecs", shell_parameter_format: :click)
  end

  test do
    ENV["AWS_ACCESS_KEY_ID"] = "test"
    ENV["AWS_SECRET_ACCESS_KEY"] = "test"
    ENV["AWS_DEFAULT_REGION"] = "us-east-1"

    output = shell_output("#{bin}/ecs run TEST_CLUSTER TEST_TASK 2>&1", 1)
    assert_match "Unknown task definition arn: TEST_TASK", output

    assert_match version.to_s, shell_output("#{bin}/ecs --version")
  end
end
