class Awsweeper < Formula
  desc "CLI tool for cleaning your AWS account"
  homepage "https://github.com/jckuester/awsweeper/"
  url "https://github.com/jckuester/awsweeper/archive/v0.10.1.tar.gz"
  sha256 "0b97b127312d65ef4d08972a0f337d8ceb1550940160b50ada0d1aaa3c723d9c"
  license "MPL-2.0"
  head "https://github.com/jckuester/awsweeper.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e0b61214e9db15dea9a6a87a7ec434a0ffe3e86c75c80fe6aaa6d436483a5cad" => :catalina
    sha256 "5f781a42c16de3ce223e02b5e31fc7714970a9528badc86457648e00b14f4ef7" => :mojave
    sha256 "cbb4f2723713a9c3a0623dd703ce121408ac7470977f691f6fb331f8c99eda64" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jckuester/awsweeper/internal.version=#{version}
      -X github.com/jckuester/awsweeper/internal.date=#{Date.today}
    ]

    system "go", "build", *std_go_args, "-ldflags", ldflags.join(" ")
  end

  test do
    (testpath/"filter.yml").write <<~EOS
      aws_autoscaling_group:
      aws_instance:
        - tags:
            Name: foo
    EOS

    assert_match "failed to initialize Terraform AWS Providers",
      shell_output("#{bin}/awsweeper --dry-run #{testpath}/filter.yml 2>&1", 1)

    assert_match "Delete AWS resources via a YAML filter", shell_output("#{bin}/awsweeper --help 2>&1", 2)
  end
end
