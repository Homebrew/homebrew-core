class Hey < Formula
  desc "HTTP load generator, ApacheBench (ab) replacement"
  homepage "https://github.com/rakyll/hey"
  url "https://github.com/rakyll/hey.git",
    :tag      => "v0.1.3",
    :revision => "36f181ad99713ffd70c09a021ea8a689b8fb43d3"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "833f09f5322dd41cc3438f9880d557941652073d02acc2971181aa1c5b4f6a7d" => :catalina
    sha256 "902d975f8dbc7f27890d56eed1a377bd880225b6860e2e7db6fed4f03e58c077" => :mojave
    sha256 "2111023b9742683d7beb4c1383f59daff60fe019ffcf5fbc91d9e3f68386dc5f" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"hey"
    prefix.install_metafiles
  end

  test do
    output = "[200]	200 responses"
    assert_match output.to_s, shell_output("#{bin}/hey https://google.com")
  end
end
