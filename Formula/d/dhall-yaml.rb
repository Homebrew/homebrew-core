class DhallYaml < Formula
  desc "Convert between Dhall and YAML"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/main/dhall-yaml"
  url "https://hackage.haskell.org/package/dhall-yaml-1.2.12/dhall-yaml-1.2.12.tar.gz"
  sha256 "e288091b568cfba756eb458716fb84745eb2599a848326b3eb3b45a5aa0008ea"
  license "BSD-3-Clause"
  head "https://github.com/dhall-lang/dhall-haskell.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "dfe3dab1ecaaf096cc239883255676d3f441a446b8fe43c7928cf355a5f37467"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f9f9399367012591352d6df9fd8c1c66a3956a9ed6d31707cb9a45ca1397f58a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47ddd725cf808f4ee04e3bb217e3a54a23dc3c91db1c77fb4b0985ea6a6edd51"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45441a856fa1a3b3794608ecc0c9500fae68ad089adcc3698f5a59ba7125ea7a"
    sha256 cellar: :any_skip_relocation, sonoma:         "e284407208df9a5e48874e297ae5b959525d7de877fac148f5cf76aa9104003b"
    sha256 cellar: :any_skip_relocation, ventura:        "3d8172163ef684ea6612f87972161c4a1e0527f0a4e1d8108032bc40d6a73d8d"
    sha256 cellar: :any_skip_relocation, monterey:       "63b5a9360c083143320cdba1e3e2d3d9c28784cc7d0cdcf3fbf885579379eab7"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "665b32d846ffab9fc4449756daaaa03bc428bd4b1aad881d3e3bba0781b65498"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b906ee758e3780cf57c12d8c4229f0c33781f1d8b82e5ef73ff9c31c4ac72c86"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.10" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    args = []
    if build.stable?
      # Backport support for GHC 9.10
      args += ["--allow-newer=dhall-json:aeson", "--allow-newer=dhall-json:text"]
      inreplace "#{name}.cabal" do |s|
        # https://github.com/dhall-lang/dhall-haskell/commit/587c0875f9539a526037712870c45cc8fe853689
        s.gsub! "aeson                     >= 1.0.0.0   && < 2.2 ,",
                "aeson                     >= 1.0.0.0   && < 2.3 ,"
        # https://github.com/dhall-lang/dhall-haskell/commit/277d8b1b3637ba2ce125783cc1936dc9591e67a7
        s.gsub! "text                      >= 0.11.1.0  && < 2.1 ,",
                "text                      >= 0.11.1.0  && < 2.2 ,"
      end
    end

    system "cabal", "v2-update"
    system "cabal", "v2-install", *args, *std_cabal_v2_args
  end

  test do
    assert_match "1", pipe_output("#{bin}/dhall-to-yaml-ng", "1", 0)
    assert_match "- 1\n- 2", pipe_output("#{bin}/dhall-to-yaml-ng", "[ 1, 2 ]", 0)
    assert_match "null", pipe_output("#{bin}/dhall-to-yaml-ng", "None Natural", 0)
  end
end
