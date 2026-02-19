class Ferron < Formula
  desc "Fast, memory-safe web server written in Rust"
  homepage "https://www.ferronweb.org/"
  url "https://github.com/ferronweb/ferron/archive/refs/tags/2.5.5.tar.gz"
  sha256 "e4bfd513d87ce32043c9f28cfb74b58c8b610f610bba79c59a0ff57370e0578c"
  license "MIT"
  head "https://github.com/ferronweb/ferron.git", branch: "develop-2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a78ad2dcfd18eb4bb4a6e43b167602800c469d4a4e98543594500c363a7417ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c975191d2bf51dbc1a3e47763ec80b831f53cb256be4eb7de78b3bcb5ffffdc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c07bf9c625cd11d0297d4102fcab9d5e3d603bd3573582f966475c1b31d0dbda"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee5550b14ce9ed6b6e99c17b76a4e2f56c716f942e8e59189826339644a0c9bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0916ae5fbb6fea267ab42ab47d5ec3fc4634895018f184e9cc08252bccccb5f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e0bd422a75596f1cbf1a1496cbe9fb1c10ef8686ac9d1b4021ac71e5ef8e2d3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "ferron")
  end

  test do
    port = free_port

    (testpath/"ferron.yaml").write "global: {\"port\":#{port}}"
    expected_output = <<~HTML.chomp
      <!doctype html>
             <html lang="en">
                 <head>
                     <meta charset="UTF-8" />
                     <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                     <title>404 Not Found</title>
                     <style>html,
      body {
          margin: 0;
          padding: 0;
          font-family:
              system-ui,
              -apple-system,
              BlinkMacSystemFont,
              "Segoe UI",
              Roboto,
              Oxygen,
              Ubuntu,
              Cantarell,
              "Open Sans",
              "Helvetica Neue",
              sans-serif;
          background-color: #ffffff;
          color: #0f172a;
      }

      body {
          padding: 1em;
          -webkit-box-sizing: border-box;
          -moz-box-sizing: border-box;
          box-sizing: border-box;
          width: 100%;
          max-width: 1280px;
          margin: 0 auto;
      }

      header {
          text-align: center;
      }

      h1 {
          font-size: 2.5em;
      }

      a {
          color: #f47825;
      }

      @media screen and (max-width: 512px) {
          h1 {
              font-size: 2em;
          }
      }

      @media screen and (prefers-color-scheme: dark) {
          html,
          body {
              background-color: #14181f;
              color: #f2f2f2;
          }
      }
      </style>
      <style>html {
          height: 100%;
      }

      body {
          display: table;
          -webkit-box-sizing: border-box;
          -moz-box-sizing: border-box;
          box-sizing: border-box;
          width: 100%;
          height: 100%;
      }

      .error-container {
          display: table-cell;
          vertical-align: middle;
          text-align: center;
      }

      .error-code {
          display: block;
          font-size: 4em;
      }

      .error-message {
          display: block;
      }
      </style>
                 </head>
                 <body>
                     <main class="error-container">
            <h1>
                <span class="error-code">404</span>
                <span class="error-message">Not Found</span>
            </h1>
            <p class="error-description">The requested resource wasn't found. Double-check the URL if entered manually.</p>
        </main>
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
