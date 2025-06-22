class Checkoutmerge < Formula
  desc "A fast and simple way to avoid having to git checkout and then git merge!"
  homepage "https://github.com/thackerdynasty/CheckoutMerge"
  url "https://github.com/thackerdynasty/CheckoutMerge/archive/refs/tags/1.0.0.tar.gz"
  sha256 "82a8f637091578b559e16c17f97c5b4094d39f398aa9f62554ab8aa044aa4bd0"
  license "AGPL-3.0-only"

  depends_on macos: :ventura
  uses_from_macos "git"
  depends_on xcode: ["16.0", :build]

  def install
    system "xcodebuild", "-project", "CheckoutMerge.xcodeproj",
                         "-scheme", "CheckoutMerge",
                         "-configuration", "Release",
                         "-derivedDataPath", "build",
                         "CODE_SIGNING_ALLOWED=NO",
                         "CODE_SIGNING_REQUIRED=NO",
                         "CODE_SIGN_IDENTITY=",
                         "-IDEPackageSupportDisableManifestSandbox=1",
                         "-IDEPackageSupportDisablePluginExecutionSandbox=1"
    bin.install "build/Build/Products/Release/CheckoutMerge"
  end

  test do
    system "mkdir", "test_repo"
    Dir.chdir("test_repo") do
      system "git", "init"
      system "touch", "file1.txt"
      system "git", "add", "file1.txt"
      system "git", "commit", "-m", "Initial commit"
      system "git", "checkout", "-b", "feature-branch"
      system "touch", "file2.txt"
      system "git", "add", "file2.txt"
      system "git", "commit", "-m", "Add file2.txt"
      system bin/"CheckoutMerge", "main", "feature-branch"
      assert_path_exists "file2.txt", "file2.txt should exist after merge"
    end
    system "false"
  end
end
