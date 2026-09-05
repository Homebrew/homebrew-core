class Plakar < Formula
  desc "Create backups with compression, encryption and deduplication"
  homepage "https://plakar.io"
  url "https://github.com/PlakarKorp/plakar/archive/refs/tags/v1.1.5.tar.gz"
  sha256 "0358c57accf22cc002273b38b77c8ef4f8e26f5bfa3027e81dee537829387ebd"
  license "ISC"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2042d5af540efff3d58634fd22ce32fd021354467599efc8ff03f51f43960b2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb937e52f2343015ed1d963f0166b0253f7dbcfceea5eb35eb109425128f88a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1679978294ab55dafca05a194a0f033cdf0712c9839be18d57cf13ab7f788e11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "355b96d1cf4594a2208943bd90894bb84bbc93bdc86670472abd4071dec9039c"
    sha256 cellar: :any,                 x86_64_linux:  "0504f975d9dfa425189ca08941412ddc5c1ce13df4cdb3520815398b4b75bf9f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/plakar version")

    repo = testpath/"plakar"
    ENV["PLAKAR_INSECURE_PLAINTEXT"] = "1"
    system bin/"plakar", "at", repo, "create", "-plaintext", "-no-compression"
    assert_path_exists repo
    assert_match "Repository", shell_output("#{bin}/plakar at #{repo} info")
  end
end
