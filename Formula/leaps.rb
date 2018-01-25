class Leaps < Formula
  desc "Collaborative web-based text editing service written in Golang"
  homepage "https://github.com/jeffail/leaps"
  url "https://github.com/Jeffail/leaps.git",
      :tag => "v0.8.2",
      :revision => "2c202c42175c97b266868836caf54df82aeffd3d"

  bottle do
    cellar :any_skip_relocation
    sha256 "09cc7b0c3ade3e507c8da0a343b38dda55d33ef1f1abfaee715e00e40049c71a" => :high_sierra
    sha256 "b1e55d4d73f30e55412ce05d3159b913e69e8e3ff47a9bb1cc6c97e6344cbed8" => :sierra
    sha256 "2c3b8c7583ffe70cfc9ce051c365accf8d9796ea248411258cb72ecce1d3dda4" => :el_capitan
    sha256 "67bb53709d2de532f4b6701261e9e5f65b6ea33ad302684c6ca8db0eed8c55b9" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOBIN"] = bin
    ENV["GOPATH"] = buildpath
    ENV["GOHOME"] = buildpath

    mkdir_p buildpath/"src/github.com/jeffail/"
    ln_sf buildpath, buildpath/"src/github.com/jeffail/leaps"

    system "go", "build", "-o", "#{bin}/leaps", "github.com/jeffail/leaps/cmd/leaps"
  end

  test do
    begin
      port = ":8080"

      # Start the server in a fork
      leaps_pid = fork do
        exec "#{bin}/leaps", "-address", port
      end

      # Give the server some time to start serving
      sleep(1)

      # Check that the server is responding correctly
      assert_match "You are alone", shell_output("curl -o- http://localhost#{port}")
    ensure
      # Stop the server gracefully
      Process.kill("HUP", leaps_pid)
    end
  end
end
