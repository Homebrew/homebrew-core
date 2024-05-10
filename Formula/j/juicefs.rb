class Juicefs < Formula
  desc "Cloud-based, distributed POSIX file system built on top of Redis and S3"
  homepage "https://juicefs.com"
  url "https://github.com/juicedata/juicefs/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "378dccf9e0ca90d3643b91bfb88bb353fb4101f41f9df9519d67d255fb18af58"
  license "Apache-2.0"
  head "https://github.com/juicedata/juicefs.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8e8da1a491e8fd381a12f74c3143a96fda4391a95421667e8a3bb9913bab4b82"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec77d856d4d478dae1e829120fb414dce0fd321f38e270a0cdbb29896166a150"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8ea98552a01f0f611fe8ac76af2cabc6c4ba27c76d1accf5d4fb4d5a955be35"
    sha256 cellar: :any_skip_relocation, sonoma:         "28fdd220a08b0b4585144b9a2043cad90165bf082a5669d200cd6e84e53de517"
    sha256 cellar: :any_skip_relocation, ventura:        "e96637f9f1e1dc2d31119470b1b0ad014d781920d79f7143fafe73d95c1ef2c2"
    sha256 cellar: :any_skip_relocation, monterey:       "a68ce69717a2873b74766ff5129e3ae9b911ef348b4192f1e92c92bf384770a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5eb55ea704a4f917c44db6eaabbac9edcf825ad9b753aa54842a5ee88c49c093"
  end

  depends_on "go@1.21" => :build # use "go" again when https://github.com/juicedata/juicefs/pull/4340 is released

  def install
    system "make"
    bin.install "juicefs"
  end

  test do
    output = shell_output("#{bin}/juicefs format sqlite3://test.db testfs 2>&1")
    assert_predicate testpath/"test.db", :exist?
    assert_match "Meta address: sqlite3://test.db", output
  end
end
