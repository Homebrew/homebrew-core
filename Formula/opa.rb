class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.47.1.tar.gz"
  sha256 "8d451b658a78bf8aea12e9692ffc83869bf85aecaafdd2d556838bd0e3df0bbf"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "14a6be5bcfb89f30474168c82f4a0938576858a517cac53d62e8a98d36bc72bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec73ba49eb03ff11dbbd9da75cea3c111ac9f69fde45e03eb01b7b49a78374c0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d6ce86ee5eca0ee91370fa91d594cf20548b7ca8d8ce470e798253cb2c4cee5d"
    sha256 cellar: :any_skip_relocation, ventura:        "674598738d871aa6415252c38117a569495f1ea23b05b76831978077df29fc4c"
    sha256 cellar: :any_skip_relocation, monterey:       "f6be91a7653ff18420a47079acfa54d426455cc9dca21222d8d5533c1a674657"
    sha256 cellar: :any_skip_relocation, big_sur:        "569b5bf1aafa9d706b6eeb71a8254d05ad4c4f2b614063419e77f9bcf1cbc499"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4071ac6b3f4d05e4215a0f530f7a72cff19b59a9e441abbfe0b0ef5252c4ba89"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/open-policy-agent/opa/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
    system "./build/gen-man.sh", "man1"
    man.install "man1"

    generate_completions_from_executable(bin/"opa", "completion")
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "+---+---+\n| x | y |\n+---+---+\n| 1 | 2 |\n+---+---+\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
