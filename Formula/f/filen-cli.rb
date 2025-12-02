class FilenCli < Formula
  desc "Interface with Filen, an end-to-end encrypted cloud storage service"
  homepage "https://github.com/FilenCloudDienste/filen-cli"
  url "https://registry.npmjs.org/@filen/cli/-/cli-0.0.34.tgz"
  sha256 "b124711dfe329029bee0475958a1fe233a61aa100c95947b71c11668aa8f45b2"
  license "AGPL-3.0-or-later"

  bottle do
    sha256                               arm64_tahoe:   "01bb3644754303d6376205e6341922a8a874c479c20272c452e0971998010951"
    sha256                               arm64_sequoia: "a2aa4f39e876f8831b242287f71c802e90f21c3495cee97271067dffc32da845"
    sha256                               arm64_sonoma:  "bd34ce54bbc156d604f8fd420f4acc8ac99ce4e695f8880a1e24ea865261ab54"
    sha256                               arm64_ventura: "954c51678d06d7c3a1e1f7f75e8b17d339b96d72c1a768fd64660bf507d533b8"
    sha256                               sonoma:        "9807b7b18bb11585ceaf4057d74cf605cc71261c816129131389451652872238"
    sha256                               ventura:       "29a98ac2cabaf393769b65aebcb7dbe3c06aec72961364d6480e52c829ac8856"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63124c5ef159ef428d16b4de0b0dc243fe30035778bccbd6f263e5423b78d247"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "028d167c8b43532da88e079138a17c3512d918ea509d6cf3c69a256f07fe5f2e"
  end

  depends_on "pkgconf" => :build
  depends_on "node"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "glib"
    depends_on "libsecret"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/filen"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/filen --version")
    assert_match "Invalid credentials!", shell_output("#{bin}/filen --email lol --password lol 2>&1", 1)
  end
end
