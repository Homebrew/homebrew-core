class Pumba < Formula
  desc "Chaos testing tool for Docker"
  homepage "https://github.com/alexei-led/pumba"
  url "https://github.com/alexei-led/pumba/archive/0.6.8.tar.gz"
  sha256 "53e4eef967620e114585627d34766caa061cf96a309b8e1a914808f90a59d49a"
  head "https://github.com/alexei-led/pumba.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1966b570bc4cedf2422c4e0dcf005553a6d1c425c85827d9643f9bebf113ab1a" => :catalina
    sha256 "186ee00f1b3662e79fe47b15a1b82ce440ccba303eb6814d496b7fca56a6c9b4" => :mojave
    sha256 "c2174ed7f82f15ac733231064de765dccf18cb6c3d1953c3046ca77aa0374486" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    src = buildpath/"src/github.com/alexei-led/pumba"
    src.install buildpath.children
    src.cd do
      system "go", "build", "-o", bin/"pumba", "-ldflags",
             "-X main.Version=#{version}", "./cmd"
      prefix.install_metafiles
    end
  end

  test do
    output = pipe_output("#{bin}/pumba rm test-container 2>&1")
    assert_match "Is the docker daemon running?", output
  end
end
