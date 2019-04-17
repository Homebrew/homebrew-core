class Pumba < Formula
  desc "Chaos testing tool for Docker"
  homepage "https://github.com/alexei-led/pumba"
  url "https://github.com/alexei-led/pumba/archive/0.6.3.tar.gz"
  sha256 "51338bcfc459a31e481dcb8a6317ea09cc914c185f00f506507d7b331b6c24a9"
  head "https://github.com/alexei-led/pumba.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "317942789fa192684210a010d2d5df1f2221dd4f2f5a2ae3f4bc164463183601" => :mojave
    sha256 "bf1be9180d45b2d64edbd4eed9522f94889de46cfa223758780cc7e0eeeefdea" => :high_sierra
    sha256 "beab419adb2b867582890409dab8a3a31f67e81fa61192a57348bef1633a7a01" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"

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
