class Dssim < Formula
  desc "RGBA Structural Similarity Rust implementation"
  homepage "https://github.com/kornelski/dssim"
  url "https://github.com/kornelski/dssim/archive/refs/tags/3.3.4.tar.gz"
  sha256 "d95c1bbcf32220d6b3d348643345eab9295acb5ef44d8cbac5e3c9c1a2d40f96"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a46f2b567b23c5da9c65895547ac70f95f9d2b7c406b7612ee27aad45e76fbd0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b7783cd8aa1bcb8798ef766048b9c755bbf84c08a3aca822506efa306e6f04e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0f5d200bb8db0c159934005fa05f62ae6bfc442bb801ed2d554ddb8b41937c45"
    sha256 cellar: :any_skip_relocation, sonoma:        "64448958181fe26a8b5a604ec1eda5cd13b0ba2fcec727b0be07018f51abc915"
    sha256 cellar: :any_skip_relocation, ventura:       "d8d9f90e34142e97ae274f9924ba33d3861c734496136db3eb36a576c1ce8118"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8546192c766b226b6ef5fd4a8ddcdaba0e07d3094d3b3146256ec37aaccf2220"
  end

  depends_on "nasm" => :build
  depends_on "rust" => :build

  # revert `cc` crate to 1.2.7, upstream pr ref, https://github.com/kornelski/dssim/pull/172
  patch do
    url "https://github.com/kornelski/dssim/commit/2f1ce12942a3f54e3822f961f5a9687c17b6cf10.patch?full_index=1"
    sha256 "12386c9fb2859c6ea3713e30303e3ddcea63ee6a591aadd53deebd33163354bc"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"dssim", test_fixtures("test.png"), test_fixtures("test.png")
  end
end
