class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.40.2.tar.gz"
  sha256 "7ac2ee7b66d1c28d95af4a2da6cd2634c87c93470c028e40856e391d4d3232d4"
  license "Apache-2.0"
  head "https://github.com/Oxen-AI/Oxen.git", branch: "main"

  # The upstream repository contains tags that are not releases.
  # Limit the regex to only match version numbers.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "09240f04b3cabaf4db1de059eb24ff1fcd713fb1c48c64887eb5d132afca6f8e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "363ddb28ad3adebb5b6d8fa757586876aa6a65398ec271cdb0646e770f8022ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "395e85f5f7449717e261490668b2b3bc6a18af0aef8644d0762d8bdd3c5eccd8"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a3bd17bfe4f47e6370f0ef84145d08a8d4e72b75743b348679d956432bf111a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16c331b53ece205502af7ebe9f13b38ddc99196974a98ffc17cf49ba2cc4403e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96d361fff0f72b0d77febfa3da43816c0731d394b1e991e83ee6d2f757d1484e"
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
    cd "oxen-rust" do
      system "cargo", "install", *std_cargo_args(path: "src/cli")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oxen --version")

    system bin/"oxen", "init"
    assert_match "default_host = \"hub.oxen.ai\"", (testpath/".config/oxen/auth_config.toml").read
  end
end
