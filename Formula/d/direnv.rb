class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/refs/tags/v2.35.0.tar.gz"
  sha256 "a7aaec49d1b305f0745dad364af967fb3dc9bb5befc9f29d268d528b5a474e57"
  license "MIT"
  head "https://github.com/direnv/direnv.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "555680f965bef99d45f35f938d1152be6d585a98b2d92833c9b511705726b7e5"
    sha256 arm64_sonoma:  "576094be0687c6c9a3aa145a8edfed09848cb9285ce304f6a206239c22674292"
    sha256 arm64_ventura: "749c61fb5908b45ae922e191156d1c1c85e92184ae4aa50356727cb006e4eaff"
    sha256 sonoma:        "78822d0960892dd2dc7cf12cd1bebd1739452a1087e084a379fa5857ad7d563b"
    sha256 ventura:       "a3f6dc3e38e4bc941f7bcf2c9391cd628ca012580f8430bbab0c8ad0a77ebe06"
    sha256 x86_64_linux:  "6c55923c4fb0ebe30e96bc5909fa94543591cf36b2e5d72cff697c5e7c540139"
  end

  depends_on "go" => :build
  depends_on "bash"

  def install
    system "make", "install", "PREFIX=#{prefix}", "BASH_PATH=#{Formula["bash"].opt_bin}/bash"
  end

  test do
    system bin/"direnv", "status"
  end
end
