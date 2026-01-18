class Gotop < Formula
  desc "Terminal based graphical activity monitor inspired by gtop and vtop"
  homepage "https://github.com/xxxserxxx/gotop"
  url "https://github.com/xxxserxxx/gotop/archive/refs/tags/v4.2.0.tar.gz"
  sha256 "e9d9041903acb6bd3ffe94e0a02e69eea53f1128274da1bfe00fe44331ccceb1"
  license "BSD-3-Clause"
  head "https://github.com/xxxserxxx/gotop.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "2df77e8cb01b137d9bd919582a8b7860e482d45b8f4e0249dbee557e63d4724f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "5c500e1f45ee743f9628545a7de331e9729a90693be2f5dfea3d297bb7d8772d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2ca9e4643126c9f07e728798d9c784b613d03bb6a947b7641b7e6e702f39a94e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "59120887e3b8c12144e56945486da0ba9cb53ca1f3c9242e9992c2d79debc119"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26f36d53f4f63536d74c2565a66595f2b5658ff0322e123486fdc2df73fcc9ff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9a4ec909ce13bf1627374bc35a3e5f55a6e897cb14fb779d677a0c715d580c22"
    sha256 cellar: :any_skip_relocation, sonoma:         "e16d440d5b7db710a63baa9f0d115c89c24a5980d684850df98f1f86f7e7c5ed"
    sha256 cellar: :any_skip_relocation, ventura:        "16826d2a09c771408f8686dd3eb2be2e354b457c5e81d14d331498e4a8768e8a"
    sha256 cellar: :any_skip_relocation, monterey:       "967cf5ea968270791932cef90aaeb8c131a695e142429d72a1694508c6a01dda"
    sha256 cellar: :any_skip_relocation, big_sur:        "61f87b013e7a20046a34ef65bfeb2cbc68a6e78df6f04baee64fa1bdc5be2d66"
    sha256 cellar: :any_skip_relocation, catalina:       "3948c3cf1d4a198462af0bbed422215a12bcd87266af2c9dd629eed8bcc27a6f"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "0c1f077e391f23aa8bb0dd8d4e1ee181b0bf3416c50ab26f718c73268711b201"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b4323239fa19e80fcec5d8ef9ba94b5be4015ae9ca0be3c3a74e06a86f15f29"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X main.Version=#{version}
      -X main.BuildDate=#{time.strftime("%Y%m%dT%H%M%S")}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/gotop"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gotop --version").chomp

    system bin/"gotop", "--write-config"
    conf_path = if OS.mac?
      "Library/Application Support/gotop/gotop.conf"
    else
      ".config/gotop/gotop.conf"
    end
    assert_path_exists testpath/conf_path
  end
end
