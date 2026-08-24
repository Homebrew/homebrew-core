class GoAir < Formula
  desc "Live reload for Go apps"
  homepage "https://github.com/air-verse/air"
  url "https://github.com/air-verse/air/archive/refs/tags/v1.67.4.tar.gz"
  sha256 "d74de50458f4f2cd744bb08a1acf84dbbcc99138ea0682176568f9a381a81887"
  license "GPL-3.0-or-later"
  head "https://github.com/air-verse/air.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "298a3377feaa535b41040e524c813958f6374016ca91996c7711ed10413c8f34"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "298a3377feaa535b41040e524c813958f6374016ca91996c7711ed10413c8f34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "298a3377feaa535b41040e524c813958f6374016ca91996c7711ed10413c8f34"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f7fec5d7f85a7911971bd04fd566948733d63ffe2b1e3dfdaa1b27d7e8635df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b540d379aac2dee69fbe145d141a6a3d81d33ae9692b552a949122e35d5cab41"
    sha256 cellar: :any,                 x86_64_linux:  "6dff62d5f79265ed34c9f1cd4a5033f38766bf1887c0ba5721edbb5bc5354056"
  end

  depends_on "go"

  conflicts_with "air", because: "both install binaries with the same name"

  def install
    ldflags = %W[
      -X main.BuildTimestamp=#{time.iso8601}
      -X main.airVersion=v#{version}
      -X main.goVersion=#{Formula["go"].version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"air")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/air -v 2>&1")
    (testpath/"air-test").mkpath
    cd testpath/"air-test" do
      system "go", "mod", "init", "air-test"
      system bin/"air", "init"
    end
    assert_path_exists testpath/"air-test/.air.toml"
  end
end
