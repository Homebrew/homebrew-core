class Ferron < Formula
  desc "Fast, memory-safe web server written in Rust"
  homepage "https://www.ferronweb.org/"
  url "https://github.com/ferronweb/ferron/archive/refs/tags/2.4.1.tar.gz"
  sha256 "8c21fe5321f0c17850c60c86758fec93c989e942f1fa2649d4baf9c0c0f711e5"
  license "MIT"
  head "https://github.com/ferronweb/ferron.git", branch: "develop-2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "593187f2c21a5939663b06815847084daabc36682896b8b0ee4fd19d8822ff9e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4cd2d2282a3d4911925111256a20069c88af08be5984e33408849d5cec5c1305"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af74f1e57f779d4c686630fd0a56122a4926c125ab527e434ab2a66ea81b68ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "833abcdce28bac3093b5689cfb318e491a28c9bf45796b3627585ff47ec8ba2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84f7cf414e5b73e300ea71fb6868968b91a4bf496bbe71308c2aa52f354f96e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "579232ad25d3a0be2aae050a80a5e39ffb9e5c3b311d34215d21e3d821fc34f3"
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
