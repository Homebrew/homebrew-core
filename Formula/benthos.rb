class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v2.9.3.tar.gz"
  sha256 "40c8e53081ce6ea115dad574769f74b0cd7de467ec4f2212747d867bb10e96bc"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"

    src = buildpath/"src/github.com/Jeffail/benthos"
    src.install buildpath.children
    src.cd do
      system "make", "VERSION=2.9.3"
      bin.install "target/bin/benthos"
    end
  end

  test do
    benthos_version = shell_output("#{bin}/benthos --version | sed -nEe '/Version:/p'")
    assert_match "Version: #{version}", benthos_version.strip
  end
end