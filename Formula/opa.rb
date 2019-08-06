class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.13.0.tar.gz"
  sha256 "1fee3f4e78749414667d6d1148774e3aed38abe8ab250fa88e9884e191a05260"

  bottle do
    cellar :any_skip_relocation
    sha256 "cc29253c80c7349395c0ce774cc50b29a2310961fc619accb8861f907241aa66" => :mojave
    sha256 "53e73f344b15003d4568a2fd005e06100adda8052fa9b511db7b5a5be852cb6e" => :high_sierra
    sha256 "c4305ad6dcfa3417ff600bc6c8f9ec2b36b8bd446d5dd606ff97011fa32d3614" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/open-policy-agent/opa").install buildpath.children

    cd "src/github.com/open-policy-agent/opa" do
      system "go", "build", "-o", bin/"opa", "-installsuffix", "static",
                   "-ldflags",
                   "-X github.com/open-policy-agent/opa/version.Version=#{version}"
      prefix.install_metafiles
    end
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "+---+---+\n| x | y |\n+---+---+\n| 1 | 2 |\n+---+---+\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
