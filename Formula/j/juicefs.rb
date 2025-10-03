class Juicefs < Formula
  desc "Cloud-based, distributed POSIX file system built on top of Redis and S3"
  homepage "https://juicefs.com"
  url "https://github.com/juicedata/juicefs/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "c2d098797bb9bc0bcb75ac1461cd1c06a8306dd3375a6d221f17c2eed091fee6"
  license "Apache-2.0"
  head "https://github.com/juicedata/juicefs.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "38575f6b8e1bc4a3d72976ad430504dc8a5f39787e22750e69d247d4874f8c90"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a85d6e3e393c2a94d1daea94c848764aae4251441cdcfdb8b119b70231fc8f5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aec5445b9982dc0262b0db8dc2969827092711e47a8afa825767b693388cbff7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "006ccb5b34cbf4435ebe004d1cc7d862f86b29456f615a9b6b74c101115ea80d"
    sha256 cellar: :any_skip_relocation, sonoma:        "f47708561eee3ff825e19eaf696d29c47a29b5bfe2288f09d3a4ed2f48a57281"
    sha256 cellar: :any_skip_relocation, ventura:       "41f32f57eab115f43d3c4bd31b7f051e3b2574f9d9dd07d8a8338eeae6b34a7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9752a4c492028c7b72fd115e6d8d9d710ce2ff44d85cd072b5f0de9197b85230"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43fc94fc1cb21d4382e90bddc14dedf71f80507dd767f5c9fe35f644be7128bb"
  end

  depends_on "go" => :build

  def install
    system "make"
    bin.install "juicefs"
  end

  test do
    output = shell_output("#{bin}/juicefs format sqlite3://test.db testfs 2>&1")
    assert_path_exists testpath/"test.db"
    assert_match "Meta address: sqlite3://test.db", output
  end
end
