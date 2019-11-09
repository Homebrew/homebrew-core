class Dive < Formula
  desc "Tool for exploring each layer in a docker image"
  homepage "https://github.com/wagoodman/dive"
  url "https://github.com/wagoodman/dive.git",
    :tag      => "v0.9.1",
    :revision => "bfcfc54ee34b623274a91ca48379ac229b5415c2"

  bottle do
    cellar :any_skip_relocation
    sha256 "427fa8fde6629b4709785e5e03e1269a128c73ba0006dd82db717173b091c08b" => :catalina
    sha256 "9f4ec5b1ed70dd7b1b104f6421ebffe800ae7eb1dd8ff901ebdf5b75c58c3db6" => :mojave
    sha256 "85ab640f05d6cd0078165fd60ce8fc813b98aae1c6a8a52ac1dbf514b463a5a8" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/wagoodman/dive"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "-ldflags", "-s -w -X main.version=#{version}", "-o", bin/"dive"
      prefix.install_metafiles
    end
  end

  test do
    (testpath/"Dockerfile").write <<~EOS
      FROM alpine
      ENV test=homebrew-core
      RUN echo "hello"
    EOS

    assert_match "dive #{version}", shell_output("#{bin}/dive version")
    assert_match "Building image", shell_output("CI=true #{bin}/dive build .", 1)
  end
end
