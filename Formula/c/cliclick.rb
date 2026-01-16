class Cliclick < Formula
  desc "Tool for emulating mouse and keyboard events"
  homepage "https://www.bluem.net/jump/cliclick/"
  url "https://github.com/BlueM/cliclick/archive/refs/tags/5.1.tar.gz"
  sha256 "58bb36bca90fdb91b620290ba9cc0f885b80716cb7309b9ff4ad18edc96ce639"
  license "BSD-3-Clause"
  head "https://github.com/BlueM/cliclick.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "5c8f28d14d1ce1102ef17284756944a808bab97b0ee2d8dcb66ee1b58350d6fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "275cd8511ab45ec069851af600597c453ed20b7c63fc6fc01d9cc9693a965282"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3c0d008172484bc0a36ea4582ff2e462396620bd2d180a02427585aec66f48e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4abfe0f72c6ab0473639cfd9a523927384f4d5de04c034e4c343db8f7f97291a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f06719b325bfd00c2aa4af5d8f4017c1d84b85228b191955d63a0d064ffd219a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c7a5cbf3668f3cc8ef45be0f90d2de0bb5803abaf750d0ca77d1f19464e81e22"
    sha256 cellar: :any_skip_relocation, sonoma:         "cc2e503d5ee81ceb4c7aab8878587ec9510074bb1706cb68d49379e574ed3136"
    sha256 cellar: :any_skip_relocation, ventura:        "2f0979882eaa7e88c3da7c8c77522a2c36eb4f587b52a8dea60459156d7bbe39"
    sha256 cellar: :any_skip_relocation, monterey:       "021849385e2be5067946b18bb27d5fdad68d82d40d776f4e6ef98abe45379d68"
    sha256 cellar: :any_skip_relocation, big_sur:        "2a52d08ab8c32e39912191316022fbc11e264b41cebe15ce6276e1a73d801011"
    sha256 cellar: :any_skip_relocation, catalina:       "65b6fcb0620720f8cc572bd3cc7ab260664e39629b9ff4fdf26e5fa24f81e6ea"
  end

  depends_on :macos

  def install
    # Uses obsolete CGWindowListCreateImage and open PR doesn't work
    # Issue ref: https://github.com/BlueM/cliclick/issues/178
    ENV["MACOSX_DEPLOYMENT_TARGET"] = "14.0" if MacOS.version >= :sequoia

    system "make"
    bin.install "cliclick"
  end

  test do
    system bin/"cliclick", "p:OK"
  end
end
