class Container < Formula
  desc "Create and run Linux containers using lightweight virtual machines"
  homepage "https://apple.github.io/container/documentation/"
  url "https://github.com/apple/container/archive/refs/tags/0.1.0.tar.gz"
  sha256 "1e82d56b5c8ccb9212a1da8e18c9ed099a8a41b928e7951fee841637270f3b02"
  license "Apache-2.0"
  head "https://github.com/apple/container.git", branch: "main"

  depends_on xcode: ["26.0", :build]
  depends_on macos: :sequoia
  uses_from_macos "swift" => :build

  def install
    if build.head?
      ENV["GIT_COMMIT"] = system "git", "rev-parse", "HEAD"
    else
      ENV["RELEASE_VERSION"] = version
    end

    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end

    system "swift", "build", *args, "--configuration", "release", "--product", "container"
    bin.install ".build/release/container"
  end

  # service do
  #   run [opt_bin/"container", "system", "start"]
  #   keep_alive true
  #   working_dir var
  #   log_path var/"log/container.log"
  #   error_log_path var/"log/container.log"
  # end

  test do
    system bin/"container", "system", "start"
    container_cmd = "\"echo 'Hello, world!' › index.html ; python3 -m http.server 88 --bind 0.0.0.0\""
    container_id = shell_output("#{bin}/container container run -it --m -d python:slim sh -c #{container_cmd}")
    assert_match(container_id, shell_output("#{bin}/container ls"))
  end
end
