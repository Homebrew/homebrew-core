class Hey < Formula
  desc "HTTP load generator, ApacheBench (ab) replacement"
  homepage "https://github.com/rakyll/hey"
  url "https://github.com/rakyll/hey.git",
    :tag      => "v0.1.2",
    :revision => "01803349acd49d756dafa2cb6ac5b5bfc141fc3b"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"

    dir = buildpath/"src/github.com/rakyll/hey"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "-o", bin/"hey"
      prefix.install_metafiles
    end
  end

  test do
    output = "[200]	200 responses"
    assert_match output.to_s, shell_output("#{bin}/hey https://google.com")
  end
end
