class Magika < Formula
  desc "Fast and accurate AI powered file content types detection"
  homepage "https://securityresearch.google/magika/"
  url "https://github.com/google/magika/archive/refs/tags/cli/v1.0.2.tar.gz"
  sha256 "bae42b31c8f419f34043cc2cf26fa42d2ade7f7c91e2fb54919914432f799699"
  license "Apache-2.0"

  head "https://github.com/google/magika.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e6ee660187e00222ac8f275a6dcc58fe871223bc94f452297cff6d476687810"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d87dee8374e75497ba0a08bff854158560f55d4875939654e5512b3a6c80b706"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e62da9eb3b91e53f1e38a2128344e6edf75bafdd4c857678ebeb82cfb0406b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "9de81c192a555a3354d7d84c644e6bcff977eef3b64efd95e81b014a2c629971"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "236bb3ef4c60314dbadb3ec928f32056372f1c27d49a8c3974f60aef1248f6ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18f9da459f002f582bf144208f7c3edb44a58025b7da24283797980216849cdf"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  # Fix x86_64 build compatibility for ort/ndarray, upstream PR ref,
  # https://github.com/google/magika/pull/1312
  patch do
    url "https://github.com/chenrui333/magika/commit/f56ab8a0806c67a2ae87edc6cd032684d592b978.patch?full_index=1"
    sha256 "7a3f701733c4df5ef0aceba3b7854f1d8e0f2a23c4fda95804911b0fa5e6ab9c"
  end

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    system "cargo", "install", *std_cargo_args(path: "rust/cli")
  end

  test do
    assert_match "text/markdown", shell_output("#{bin}/magika -i #{prefix}/README.md")
  end
end
