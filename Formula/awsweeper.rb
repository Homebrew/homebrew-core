class Awsweeper < Formula
  desc "CLI tool for cleaning your AWS account"
  homepage "https://github.com/jckuester/awsweeper/"
  url "https://github.com/jckuester/awsweeper/archive/v0.10.2.tar.gz"
  sha256 "9b9f1f68af14e582a752dfd5ceda79d22f3b3574ac68331b0e2c312e87acb5df"
  license "MPL-2.0"
  head "https://github.com/jckuester/awsweeper.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "584e94945ee6f5e5d1d436cfa6817d60405787ed0dd8390919d8ada6da750a26" => :catalina
    sha256 "844e62f7429517656ad31c7fe590b023950b2ee87200fe6288a03dd337a2e9fd" => :mojave
    sha256 "5e397a0b681188855c9ace13381aa06083b56e67159413cc76b26a5047d81656" => :high_sierra
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
