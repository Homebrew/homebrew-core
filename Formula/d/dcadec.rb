class Dcadec < Formula
  desc "DTS Coherent Acoustics decoder with support for HD extensions"
  homepage "https://github.com/foo86/dcadec"
  url "https://github.com/foo86/dcadec.git",
      tag:      "v0.2.0",
      revision: "0e074384c9569e921f8facfe3863912cdb400596"
  license "LGPL-2.1-or-later"
  head "https://github.com/foo86/dcadec.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "3ae8134706fc28f0b3e951bd4dddbba4c3e13b58b61484e5988180fba679570f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0a38744f8f827e1d1b9b8cec9c825699c2d2b3f5186a05d9dc72b44ad1c5f390"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47bf0a1d239ce33c7fd85c57dd7b8aad67e69aaca2a28206d45a6f7f14d189d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d458c3484034748b9b1fee9074d5f3018354447d11914f132c6e41899de17491"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "359384000edd00fc8e030bb59f9ebc15a301eb250351a20f2da062cc202caa54"
    sha256 cellar: :any_skip_relocation, sonoma:         "fab285a35daca6aeee378d7c8a9f380c9da0def5f548b2fa4a421d59b9408ead"
    sha256 cellar: :any_skip_relocation, ventura:        "d372f413acbf37b65b3f39e2f7140d8731dab8216a683b4153428c574e87a3e6"
    sha256 cellar: :any_skip_relocation, monterey:       "702e3f8b57be59604d5969be08fb64067763e5aac353154b233ad74a3f5a3276"
    sha256 cellar: :any_skip_relocation, big_sur:        "2679a012566efff2d1ad05021648975dc2960d2ff42720d53b001631311d4a51"
    sha256 cellar: :any_skip_relocation, catalina:       "0622b87f5b7f7c71346443f12d5e3d6eabd02aa63dce433c7248d405a9fbc036"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "6218f10d2a60bde3becd795bf87e6a806219c7c88b5fcd426ce44cb95e8baef6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f727365cbd24d678682c06e73ff49a7fdf92b17a5a1c6b82068522e4d0e0b1f"
  end

  # Ref https://github.com/foo86/dcadec/commit/b93deed1a231dd6dd7e39b9fe7d2abe05aa00158
  deprecate! date: "2024-06-30", because: :deprecated_upstream
  disable! date: "2025-07-02", because: :deprecated_upstream

  def install
    system "make", "all"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    resource "homebrew-testdata" do
      url "https://github.com/foo86/dcadec-samples/raw/fa7dcf8c98c6d/xll_71_24_96_768.dtshd"
      sha256 "d2911b34183f7379359cf914ee93228796894e0b0f0055e6ee5baefa4fd6a923"
    end

    resource("homebrew-testdata").stage do
      system bin/"dcadec", resource("homebrew-testdata").cached_download
    end
  end
end
