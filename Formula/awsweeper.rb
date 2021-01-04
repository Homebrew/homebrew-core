class Awsweeper < Formula
  desc "CLI tool for cleaning your AWS account"
  homepage "https://github.com/jckuester/awsweeper/"
  url "https://github.com/jckuester/awsweeper/archive/v0.11.1.tar.gz"
  sha256 "6bd1db96a1fad22df4c22a0ce95f49f91de14c962b5599b3b9d8a730e287767d"
  license "MPL-2.0"
  head "https://github.com/jckuester/awsweeper.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "652bd03b5d0354d033cb083eb2e7841e47be80fdbe83f7ac46bc26210241052e" => :big_sur
    sha256 "6344da5e0b86eb58246a61f9acfc22496fc2b1101da333f3e132817ef54be989" => :catalina
    sha256 "3559e48f432e9e8cade108a83cc3f6289912a80c7aff322402526cb6eaa8917c" => :mojave
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

    assert_match "Error: failed to configure provider (name=aws",
      shell_output("#{bin}/awsweeper --dry-run #{testpath}/filter.yml 2>&1", 1)
  end
end
