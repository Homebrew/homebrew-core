class Honeymarker < Formula
  desc "CLI for managing markers in your honeycomb datasets"
  homepage "https://github.com/honeycombio/honeymarker"
  url "https://github.com/honeycombio/honeymarker/archive/v0.2.7.tar.gz"
  sha256 "c70e6e3ffbd8a9fb0269c338b2b93fcbe8fd6f22b6c1428c7ffecbd487d79096"
  license "Apache-2.0"
  head "https://github.com/honeycombio/honeymarker.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "Available commands:",
      shell_output("#{bin}/honeymarker --help")
  end
end
