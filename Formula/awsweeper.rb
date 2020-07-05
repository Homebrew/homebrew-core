class Awsweeper < Formula
  desc "CLI tool for cleaning your AWS account"
  homepage "https://github.com/jckuester/awsweeper/"
  url "https://github.com/jckuester/awsweeper/archive/v0.10.1.tar.gz"
  sha256 "0b97b127312d65ef4d08972a0f337d8ceb1550940160b50ada0d1aaa3c723d9c"
  license "MPL-2.0"
  head "https://github.com/jckuester/awsweeper.git"

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
