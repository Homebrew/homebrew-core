class GrpcClient < Formula
  desc "Homebrew Package for a GRPC client to query the server with integrated React UI"
  homepage "https://bhagwati-web.github.io/grpc-client"
  url "https://bhagwati-web.github.io/grpc-client/grpcui/archive/refs/tags/v0.0.1.tar.gz"
  version "0.0.1"
  sha256 "dd6d79b60862db320e182475309c9dd27e63a11011603ca3876b0309e9b6ae11"
  license "MIT"
  head "https://bhagwati-web.github.io/grpc-client/grpcui.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "214c73fbe6f480c6ccfb02f250b8dd4d3952de8e135cc9654f66c37cba9556c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d24bb707795ae45a63cae04d01a9b0fa533b6d16684f17e18e4a8b4b96d97ab0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a920cff512aaeeec7b8e400f0172916203c0c0c2433b3aa9493a97bdbaea48c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "373ffc99cf422db0d0b0022d9ecbc1c8b62e0244b650304141fc7f53aae638f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "eacbd647abb18460172fd8d564891debf9bfdfa9d3f2b864113b546efa8b00fc"
    sha256 cellar: :any_skip_relocation, ventura:       "646df535304309fa1e252a3d3307cec8150e7355572a7d5293d5bf0c2e17aac6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a4f64272b6556e9b65015dbb23dc58692ebebcd194c54380770b333fed0fdb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c1376d267c3e1c1cf937478e18b5a9343e92f0d39bcb0d5f692c95e7504163d"
  end

  # Go binary has no external dependencies - works without Go installed!
  @server_port = "50051"
  @server_url = "http://localhost:#{@server_port}"

  def install
    # Stop any running grpc-client processes before installation
    system "echo 'Checking for running GRPC Client processes...'"

    # Try to stop using the standard grpcstop command if it exists
    system "#{HOMEBREW_PREFIX}/bin/grpcstop 2>/dev/null || true" if File.exist?("#{HOMEBREW_PREFIX}/bin/grpcstop")

    # Kill any processes using the PID file
    if File.exist?(File.expand_path("~/.grpc-client.pid"))
      pid = File.read(File.expand_path("~/.grpc-client.pid")).strip
      system "kill #{pid} 2>/dev/null || true"
      system "rm -f ~/.grpc-client.pid 2>/dev/null || true"
    end

    # Kill any processes using the port as fallback
    system "lsof -t -i:#{@server_port} 2>/dev/null | xargs kill -9 2>/dev/null || true"

    # Kill any grpc-client processes by name
    system "pkill -f grpc-client 2>/dev/null || true"

    system "echo 'Installing new GRPC Client version...' #{version}"

    # Rename the downloaded binary to a standard name
    bin.install Dir["*"].first => "grpc-client"

    (bin/"grpcstart").write <<~EOS
      #!/bin/bash

      echo "Starting GRPC Client Server with integrated React UI..."

      # Start the GRPC client in background
      nohup #{bin}/grpc-client > /dev/null 2>&1 &
      GRPC_PID=$!

      # Save PID for later stopping
      echo $GRPC_PID > ~/.grpc-client.pid

      # Allow time for the server to start
      sleep 3

      echo "GRPC Client Server started successfully!"
      echo "Server is running on #{@server_url}"
      echo "React UI is available at #{@server_url}"
      echo "Use 'grpcstop' to stop the server"

      # Open the default browser with the server URL
      if command -v xdg-open > /dev/null; then
        xdg-open "#{@@server_url}"
      elif command -v open > /dev/null; then
        open "#{@@server_url}"
      else
        echo "Please open #{@@server_url} in your browser"
      fi
    EOS

    (bin/"grpcstop").write <<~EOS
      #!/bin/bash

      echo "Stopping GRPC Client Server..."

      # Try to kill using saved PID first
      if [ -f ~/.grpc-client.pid ]; then
        PID=$(cat ~/.grpc-client.pid)
        if ps -p $PID > /dev/null 2>&1; then
          kill $PID
          echo "Stopped GRPC Client Server (PID: $PID)"
        fi
        rm -f ~/.grpc-client.pid
      fi

      # Fallback: kill any process using the port
      if lsof -t -i:#{@server_port} > /dev/null 2>&1; then
        lsof -t -i:#{@server_port} | xargs kill -9
        echo "Killed any remaining processes on port #{@server_port}"
      fi

      echo "GRPC Client Server stopped successfully!"
    EOS

    # Make scripts executable
    chmod 0755, bin/"grpcstart"
    chmod 0755, bin/"grpcstop"
  end

  def post_install
    puts "\n\n\n================================================"
    puts "GRPC Client installed successfully!"
    puts ""
    puts "The server includes:"
    puts "  • gRPC client API"
    puts "  • Integrated React UI"
    puts "  • Collection management"
    puts "  • Server reflection"
    puts ""
    puts "🚀 Start server:    grpcstart"
    puts "🛑 Stop server:     grpcstop"
    puts ""
    puts "Server will be available at: #{@server_url}"
    puts "================================================"
    puts ""
    puts "🎉 Starting GRPC Client Server automatically..."
    puts ""

    # Automatically start the server after installation
    system "#{bin}/grpcstart"

    puts "\n\n"
  end
end
