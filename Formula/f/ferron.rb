class Ferron < Formula
  desc "Fast, memory-safe web server written in Rust"
  homepage "https://www.ferronweb.org/"
  url "https://github.com/ferronweb/ferron/archive/refs/tags/1.0.0.tar.gz"
  sha256 "172e7b23e5032a7caa88a86777509dd5fda9d354294b162bdefc5988b1b09fc5"
  license "MIT"
  head "https://github.com/ferronweb/ferron.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9152dde1b6e91c4e595f7f1bf3927006e10afd926ccfa3f7895aba0b59c51ffd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f802f9fb26f44f174299b4e85cb896e58183b47bbd1ababdd91573893242ea65"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "55bf7ce112938c94ee44559946f980446af8e39eeb606d380d841adaadfc1e2f"
    sha256 cellar: :any_skip_relocation, sonoma:        "175a34b4304e4ae6f2000235190b7c88a8a01ad615b159c3aeb8819a611e3b09"
    sha256 cellar: :any_skip_relocation, ventura:       "e0ef14d0ff0effe665e3542c423b7e6b3e3583ab8a11caf3c51c220662edd58c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "599548e8a0bb51b985a40eb1c212d9df58fa9059fc8fe4b17afa2710b7e72778"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "550b7c9f498d282f2f6ce7162abadf005f3a9d989fa4916fb073887411fe8eaf"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "ferron")
  end

  test do
    port = free_port

    (testpath/"ferron.yaml").write "global: {\"port\":#{port}}"
    expected_output = <<~HTML.chomp
      <!DOCTYPE html>
      <html lang="en">
      <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <title>404 Not Found</title>
      </head>
      <body>
          <h1>404 Not Found</h1>
          <p>The requested resource wasn't found. Double-check the URL if entered manually.</p>
      </body>
      </html>
    HTML

    begin
      pid = spawn bin/"ferron", "-c", testpath/"ferron.yaml"
      sleep 3
      assert_match expected_output, shell_output("curl -s 127.0.0.1:#{port}")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
