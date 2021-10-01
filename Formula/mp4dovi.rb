class Mp4dovi < Formula
  desc "Change Dolby Vision codec in MP4 files from dvhe to dvh1"
  homepage "https://github.com/rixtox/mp4dovi"
  url "https://github.com/rixtox/mp4dovi/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "969703be54566fbaa586979ed2e80c68ea1db7f5e0870ac039ec1f33087b6d8d"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-o", "mp4dovi", "mp4dovi.go"
    bin.install "mp4dovi"
  end

  test do
    # no test for now as a mp4 encoded in dvhe must be supplied
    system "true"
  end
end
