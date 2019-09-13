class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.14.0.tar.gz"
  sha256 "27a7a10dc7c7253041b03f34282c7a3228a90ac64346c7722e9f23535e8a671c"

  bottle do
    cellar :any_skip_relocation
    sha256 "6aaf57f4f3024eaab8e026844168c0175e51650354322a826e56e95b784af504" => :mojave
    sha256 "a0d3ffd8c404b2fb1fb299a5158a3459a5ec584e1aab45e6c68e0eef9074ede5" => :high_sierra
    sha256 "b1375b02a59caa361ebd411d356f49efeb7643f99e906a12a655acef8323d82c" => :sierra
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
