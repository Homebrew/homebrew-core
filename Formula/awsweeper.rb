class Awsweeper < Formula
  desc "CLI tool for cleaning your AWS account"
  homepage "https://github.com/jckuester/awsweeper/"
  url "https://github.com/jckuester/awsweeper/archive/v0.11.0.tar.gz"
  sha256 "8e407167a090e90a48610db154516dfead41b5d54907c3b54400e77007c05167"
  license "MPL-2.0"
  head "https://github.com/jckuester/awsweeper.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "950992e8f1cac1739678132bdaadae1d31d2be469c72d30de457b8a9bfea3662" => :big_sur
    sha256 "4542ed029c8bad8a0cf3dfee8ef8fd8978ae43abcda74d96b0d62e5bc10bd2ec" => :catalina
    sha256 "48f38bfc066603dd5c7694da8ec42422e59fdf7f07e9bf025cf00a95b3f1f2a2" => :mojave
    sha256 "57defdc7baa5ad321a0b0f66d5db3404f7de4e4c60df98d06a23841601f8761e" => :high_sierra
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
