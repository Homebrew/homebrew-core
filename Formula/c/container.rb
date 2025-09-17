class Container < Formula
  desc "Create and run Linux containers using lightweight virtual machines"
  homepage "https://apple.github.io/container/documentation/"
  url "https://github.com/apple/container/archive/refs/tags/0.4.1.tar.gz"
  sha256 "8a77933181577c4e459f75e392cdf8fadaede6b9917540278da3662fd712001b"
  license "Apache-2.0"
  head "https://github.com/apple/container.git", branch: "main"

  depends_on xcode: ["26.0", :build]
  depends_on arch: :arm64
  depends_on macos: :sequoia
  depends_on :macos

  def install
    if build.head?
      ENV["GIT_COMMIT"] = Utils.git_head
    else
      ENV["RELEASE_VERSION"] = version
    end

    system "swift", "build", "--disable-sandbox", "--configuration", "release"

    release_dir = buildpath/".build/release"
    bin.install release_dir/"container"
    bin.install release_dir/"container-apiserver"

    (libexec/"container/plugins/container-core-images/bin").install release_dir/"container-core-images"
    (libexec/"container/plugins/container-network-vmnet/bin").install release_dir/"container-network-vmnet"
    (libexec/"container/plugins/container-runtime-linux/bin").install release_dir/"container-runtime-linux"
  end

  # container APIs aren't guaranteed to be backward compatible,
  # so we stop the system service to ensure no components are out of sync.
  # Ref: https://github.com/apple/container/issues/551#issuecomment-3246928923
  def post_install
    system bin/"container", "system", "stop"
  end

  service do
    run [opt_bin/"container", "system", "start"]
    keep_alive true
    working_dir var
    log_path var/"log/container.log"
    error_log_path var/"log/container.log"
  end

  test do
    # Cannot fully test, as it needs to write outside testpath
    assert_match version.to_s, shell_output("#{bin}/container --version")

    output = "Error: interrupted: \"internalError: \"failed to list containers\""
    assert_match output, shell_output("#{bin}/container list 2>&1", 1)
  end
end
