class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://github.com/jgm/pandoc/archive/refs/tags/3.10.1.tar.gz"
  sha256 "faee98f42ed1592b2feb8da7fdfa87a23b679ca27ff883e06030f89c25c91ba9"
  license "GPL-2.0-or-later"
  compatibility_version 5
  head "https://github.com/jgm/pandoc.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7673c28d34a01b42c3cffd2c62e229d256b573b03820ce47bdefc4f9348c1d9e"
    sha256 cellar: :any, arm64_sequoia: "d767ddbf02c584bfc21782d28d154e705842ef2797c946060ac3e7658b55b804"
    sha256 cellar: :any, arm64_sonoma:  "35cb42e9199cce9cecb4fa5868fe805cf10d051b347decff0b48dbbc23eaba39"
    sha256 cellar: :any, sonoma:        "f6abbc2a9b1e9afabb37612ddcbbf421884a4c54ad4ea7185b78700c52c719cf"
    sha256 cellar: :any, arm64_linux:   "d8cbd5705e1ed55c573cc025de43442404bc5dbb97f2500ba431eb0a6c6c9ff3"
    sha256 cellar: :any, x86_64_linux:  "c1a7c8b4d4c13f3658a355053769935dee8fdfd68ffdbc2cd5604a9530aa3caa"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "unzip" => :build # for cabal install
  uses_from_macos "libffi"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Workaround to build aeson with GHC 9.14, https://github.com/haskell/aeson/issues/1155
    args = ["--allow-newer=base,containers,template-haskell"]
    args << "--ghc-options=-pie" if OS.linux?

    (buildpath/"cabal.project.local").write <<~EOS
      -- Use split-sections to reduce binary sizes
      if os(linux)
        package *
          split-sections: True

      -- Allow building PIE on non-ARM Linux
      if os(linux) && !arch(arm) && !arch(aarch64)
        package *
          ghc-options: -fPIC -fexternal-dynamic-refs

      -- Avoid bundled libraries in packages
      package direct-sqlite
        flags: +systemlib

      package persistent-sqlite
        flags: +systemlib +use-pkgconfig

      package system-libyaml
        flags: +system-libyaml
    EOS

    system "cabal", "v2-update"
    system "cabal", "v2-install", *args, *std_cabal_v2_args, "pandoc-cli"
    generate_completions_from_executable(bin/"pandoc", "--bash-completion",
                                         shells: [:bash], shell_parameter_format: :none)
    man1.install "pandoc-cli/man/pandoc.1"
  end

  test do
    input_markdown = <<~MARKDOWN
      # Homebrew

      A package manager for humans. Cats should take a look at Tigerbrew.
    MARKDOWN
    expected_html = <<~HTML
      <h1 id="homebrew">Homebrew</h1>
      <p>A package manager for humans. Cats should take a look at
      Tigerbrew.</p>
    HTML
    assert_equal expected_html, pipe_output("#{bin}/pandoc -f markdown -t html5", input_markdown, 0)
  end
end
