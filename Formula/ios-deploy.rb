class IosDeploy < Formula
  desc "Install and debug iPhone apps from the command-line"
  homepage "https://github.com/ios-control/ios-deploy"
  license all_of: ["GPL-3.0-or-later", "BSD-3-Clause"]
  head "https://github.com/ios-control/ios-deploy.git", branch: "master"

  stable do
    url "https://github.com/ios-control/ios-deploy/archive/refs/tags/1.12.0.tar.gz"
    sha256 "49f4835e365f6c5c986af3f4bd5c1858c1a1d110aa7f9cf45649c3617911c508"

    # fix build failure, remove in next release
    patch do
      url "https://github.com/ios-control/ios-deploy/commit/24c9efbd43f2acd25c0f3e85137e29ec3c1654cf.patch?full_index=1"
      sha256 "efc223ca219fb64c06155b1675a8a81d57ee42c18ff210c070d8d6f37c893b07"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e149d628fae457011dc5d3af6215ae3e8311ec08f4affbc96f00a3de5ef47791"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e85b52bd030eef2dfdc3f354fd4850fc6a09391e2822f48a1de8fed4d3581a4d"
    sha256 cellar: :any_skip_relocation, monterey:       "72596357a448618bd705170d5dc2ed8b69debcc06deb7ce8d7d414050fb8fd68"
    sha256 cellar: :any_skip_relocation, big_sur:        "b4490b2ef74d1e2b498bf9a5e79305dacbd2bed3c5e0dd6b93822e19953f2074"
    sha256 cellar: :any_skip_relocation, catalina:       "23244feccb6cf78da5eb83163c6a187acc3aa8248fa34eb909e1728b4876e5bb"
    sha256 cellar: :any_skip_relocation, mojave:         "2a5a3fd9d3288d48a75f4f85aaf72e98d0866edca7c5b56ba6d2ccf0d98e96b8"
  end

  depends_on xcode: :build
  depends_on :macos

  def install
    xcodebuild "-configuration", "Release",
               "SYMROOT=build",
               "-arch", Hardware::CPU.arch

    xcodebuild "test",
               "-scheme", "ios-deploy-tests",
               "-configuration", "Release",
               "SYMROOT=build",
               "-arch", Hardware::CPU.arch

    bin.install "build/Release/ios-deploy"
  end

  test do
    system "#{bin}/ios-deploy", "-V"
  end
end
