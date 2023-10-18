class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https://geph.io/"
  url "https://github.com/geph-official/geph4-client/archive/refs/tags/v4.9.6.tar.gz"
  sha256 "8a5258fbf2423af2ece951b140e91bc7b74acd0139e626ad19b3e9cd3fb9380f"
  license "GPL-3.0-only"
  head "https://github.com/geph-official/geph4-client.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9e242aa41f6114b5a7b83b946fedab134c3db6fb7ef51b493cf56400de53cf24"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "12ea89c23000ca5fd0c175eb29d2fe0af0144da810ec16762983488b90dc4709"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1495c3d42c1540d596afed9f2923b8c9801dad38b5a505835903c5a9de80872a"
    sha256 cellar: :any_skip_relocation, sonoma:         "737a19111570620ffabcdab1f103b59fbd38f1e51cc0f25e79eb4a84e14a06de"
    sha256 cellar: :any_skip_relocation, ventura:        "f59a1e81fcad9919d74c8cc2966b2d76e24e176fb97a3e3b59af36efe05db2a7"
    sha256 cellar: :any_skip_relocation, monterey:       "c565012a722fd741608d4dbd338b1d15b7961cc3a0d573f850a0ba676be4c540"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03da453e4ef6db734fab1f8e85af93857a5ed82aec2509d7c73b5d06954e4cb0"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    (buildpath/".cargo").rmtree
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Error: invalid credentials",
     shell_output("#{bin}/geph4-client sync --credential-cache ~/test.db auth-password 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/geph4-client --version")
  end
end
