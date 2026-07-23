class Geesefs < Formula
  desc "FUSE FS implementation over S3"
  homepage "https://github.com/yandex-cloud/geesefs"
  url "https://github.com/yandex-cloud/geesefs/archive/refs/tags/v0.43.8.tar.gz"
  sha256 "66383e8a6162e389037135482e93ebe6d04fb0451f98e081d87b089c94fb7ec0"
  license "Apache-2.0"
  head "https://github.com/yandex-cloud/geesefs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dab68949dbc5d1e1873b97d1213bfba8dd988e9a4d344db455b102392eb08385"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ba5f42e51f5d2d7640eb195909313c1b45261952c252142de1789ad971a7d42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5671be389e2dba3a15d1fba6632fe0bd0c35f8b56c5771ce3dbc08ba144efc6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8297b5bab027bbf2aa10b5cf1b015f7adde5057e1f994767118e0270e77bccf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22d8bf3ee942cfd12cccfccac0f21d2b4c734151a24ea572095aaf588bc734c0"
    sha256 cellar: :any,                 x86_64_linux:  "e59de261cd99aac92f91dddaf07f62bf4e6847d8ba2f34463722c405261259f6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "geesefs version #{version}", shell_output("#{bin}/geesefs --version 2>&1")
    output = shell_output("#{bin}/geesefs test test 2>&1", 1)
    assert_match "FATAL Mounting file system: Unable to access 'test'", output
  end
end
