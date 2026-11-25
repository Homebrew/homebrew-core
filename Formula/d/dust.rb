class Dust < Formula
  desc "More intuitive version of du in rust"
  homepage "https://github.com/bootandy/dust"
  url "https://github.com/bootandy/dust/archive/refs/tags/v1.2.8.tar.gz"
  sha256 "2df7ea0258025b2061e1a1819ee7fc48b69fbf8c084c5f0e51a457f37695453e"
  license "Apache-2.0"
  head "https://github.com/bootandy/dust.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "510d71bb2d969fd7207462d53d179b2e0506b4d8d5de54bb1c08d92c265eed4c"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "321dddc009900b921834f2fc6a91caaaa2dd8d2f4108c6046b2fa6416a5d0d34"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8ebacb83db199b15d72c2e6142dc4621a10f3ec008260bf88b8ab6f106160442"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c8a2eda2f0f6e6f9b9ab24e07b3695985d384fccdfe6af51a7d1bab297629d59"
    sha256 cellar: :any,                 arm64_linux:       "f2f523dd01df6795530be819a2bbe532d2866b7b464d8f8df2fe1b637ea41989"
    sha256 cellar: :any,                 x86_64_linux:      "1dd05b4c101ee1055abde38d04a3437df408aa6d42da13b501f0ed588e2664ad"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "completions/dust.bash" => "dust"
    fish_completion.install "completions/dust.fish"
    zsh_completion.install "completions/_dust"

    man1.install "man-page/dust.1"
  end

  test do
    # failed with Linux CI run, but works with local run
    # https://github.com/Homebrew/homebrew-core/pull/121789#issuecomment-1407749790
    if OS.linux?
      system bin/"dust", "-n", "1"
    else
      assert_match(/\d+.+?\./, shell_output("#{bin}/dust -n 1"))
    end
  end
end
