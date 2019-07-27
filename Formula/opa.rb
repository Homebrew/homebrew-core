class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.12.2.tar.gz"
  sha256 "18526397af34f542924b67d057a035f2b1927db7f8a5995956de1872bdc46f62"

  bottle do
    cellar :any_skip_relocation
    sha256 "61699a95be15017f09bfff7890ee22f0b5346479d553088a4ca917368ee1656a" => :mojave
    sha256 "eeb7345437ff11f400633132730e236ba36ed2f5273bb071000b5bd0b8017b46" => :high_sierra
    sha256 "0a79d88b22cea9f9fd63a78d38d0237a69f6ffcb5792df65ae997fb61357fb05" => :sierra
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
