class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.35.0.tar.gz"
  sha256 "f8301be0615b5e489ea7ec6811a04e6730424c05710b22453b3b1c66e946dcf9"
  license "Apache-2.0"
  head "https://github.com/Oxen-AI/Oxen.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8793e7c834bac7cf51526e4bc397f60959aad9ba2582547deb3648d997ef7f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5028a4c4023327ee842b9e609b3ea7c1c0a00e4d335ff853bb79d93bd4b948c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "854c2db0bbc9098ac8a2bd518d0a4e0aa0743680f8a098a0ccd00b5e75e7533e"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d156ebc9ad223b4c2740de009fb2c7ed5cb8398bbb3afb8a8b443675c88649c"
    sha256 cellar: :any_skip_relocation, ventura:       "9003f44c38e1210ff649904a81a267b238e411b92d8c7a9b6ffc4c09b0c3ed19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0ad60cfb5dad9e31709a8b65301315a9afdfe2ad8aa2698085c8d3065888c4d"
  end

  depends_on "cmake" => :build # for libz-ng-sys
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "llvm" # for libclang

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oxen --version")

    system bin/"oxen", "init"
    assert_match "default_host = \"hub.oxen.ai\"", (testpath/".config/oxen/auth_config.toml").read
  end
end
