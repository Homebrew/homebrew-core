class Ipatool < Formula
  desc "CLI tool for searching and downloading app packages from the iOS App Store"
  homepage "https://github.com/majd/ipatool"
  url "https://github.com/majd/ipatool/archive/refs/tags/v2.3.2.tar.gz"
  sha256 "669630b7bd181d90ce4a2aa45d5a10548e7a31894bc0eedcef2d709c14bfecd1"
  license "MIT"
  head "https://github.com/majd/ipatool.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "535357deb150616f76de23f7ac760a4351c6632693e812bedaddfdf2db47837e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e8771042c5076a895e6f200235e9f96ef75a6f8270cd936fd22da70cb7259d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1673aa30a9d1a3e9dd7a6f20b956fdf17d66d96ed7d8971fca18be588b0da5a"
    sha256 cellar: :any_skip_relocation, sonoma:        "0383f256bd5a51644773085af1173fd11c97884f827d4dc7351ba7d8a8ce99be"
    sha256 cellar: :any,                 arm64_linux:   "656466f4e4c2fd188d1fea77ca3303b6ebd1ba41b85b4532ff71793f83f8ce6d"
    sha256 cellar: :any,                 x86_64_linux:  "ce2ba60dacd1f16688d2b96153a4f538809dd26cd6c3d5e383522f4508582996"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"
    system "go", "build", *std_go_args(ldflags: "-X github.com/majd/ipatool/v2/cmd.version=#{version}")

    generate_completions_from_executable(bin/"ipatool", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ipatool --version")

    output = shell_output("#{bin}/ipatool auth info 2>&1", 1)
    assert_match "failed to get account", output
  end
end
