class Elvish < Formula
  desc "Friendly and expressive shell"
  homepage "https://github.com/elves/elvish"
  url "https://github.com/elves/elvish/archive/v0.13.1.tar.gz"
  sha256 "83275a4c36f66b831ba4864d1f5ffdc823616ed0a8e41b2a9a3e9fcba9279e27"
  head "https://github.com/elves/elvish.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "95d0ba1cd11926f557c3fd4c1469bee75f0fd57d50f112d653a9e38bddf5acde" => :catalina
    sha256 "924589665ab16270187a6bb836b685df927db24d4f770557ad9413e6c6f01c23" => :mojave
    sha256 "0eda28eadf0e9e4bf6161ccb199eea49267e3085e6180b8b607827cdeca2bcda" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags",
           "-X github.com/elves/elvish/pkg/buildinfo.Version=#{version}"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/elvish -version").chomp
    assert_match "hello", shell_output("#{bin}/elvish -c 'echo hello'")
  end
end
