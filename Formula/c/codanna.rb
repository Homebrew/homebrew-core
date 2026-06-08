class Codanna < Formula
  desc "Code intelligence system with semantic search"
  homepage "https://github.com/bartolli/codanna"
  url "https://github.com/bartolli/codanna/archive/refs/tags/v0.9.22.tar.gz"
  sha256 "885e927e0db2559fdcd32c3120b58be309f5e2a1cba572184e90586f078ec5ae"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47e7512adc09aec45715721bcacb7a213c7ad7ec76a4c4a1f4fff401482f07be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2c677cc637f6c6544d0be958ebc64b32bb70d5847ddff74517b38c5a7f10328"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34171eca0da9635bcb178267c6cd03266a3c46dace58f105b40cb3f23d1610a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "2df941f33d0f4edc8da5f48006bcc06b418694758aa53e2a4f10b298cb1831c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed89cbb73b3669a05ac5d458fcac3602e0eb0def32c49238f22fa01c0f2329cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2b11bd507e5a228224e9139409bc0cb252f1ca2fe1201e808ed47cd96485c9f"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args, "--all-features"
  end

  test do
    system bin/"codanna", "init"
    assert_path_exists testpath/".codanna"
  end
end
