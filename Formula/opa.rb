class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.25.1.tar.gz"
  sha256 "5ab1f0a5132bb9d2b9548b5f29b0359daabebb2fab589d32f4b9281609355a3a"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e6aaa6e6e367088407b12d3dced3b3406d82f7b62bf8d5ab0aa1ee0109ada4e0" => :big_sur
    sha256 "42dc50d3c5f5a8ba40f3d26e287800a65ad5abe203401f9ba072d22000ee6a71" => :catalina
    sha256 "e08034c1e65dd3facb85059f43053fbeec4a54ad823a6f1a8b22d3cd420bf0c8" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args,
              "-ldflags", "-X github.com/open-policy-agent/opa/version.Version=#{version}"
    system "./build/gen-man.sh", "man1"
    man.install "man1"
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "+---+---+\n| x | y |\n+---+---+\n| 1 | 2 |\n+---+---+\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
