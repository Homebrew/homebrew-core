class GrpcClient < Formula
  desc "Homebrew Package for a GRPC client to query the server with integrated React UI"
  homepage "https://bhagwati-web.github.io/grpc-client"
  url "https://bhagwati-web.github.io/grpc-client/grpcui/archive/refs/tags/v0.0.1.tar.gz"
  sha256 "7fa3039bfa6c06a688c1094177445f759c592be2f04574a234da7a88ab2d0efd"
  license "MIT"
  head "https://bhagwati-web.github.io/grpc-client/grpcui.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    # macOS ARM64 platforms
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1912dfb2b1236319068c07a5f5f3aa32d894f5e4107cac0e89ab9e6dbaacbe90"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88c266d2d4b1f0269368457432d6970ac3b4285566a1f5e0347e3d1b98e641a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "372cbcccc4110387a181bc61b02c7ee7700ee0d96091bc04844bbff1235608c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0e1524ea71ec246c1e19d3bd3d1f4cc926534b29910ba236062cea21b4ccf766"
    # macOS Intel platforms
    sha256 cellar: :any_skip_relocation, sonoma:        "2f1ed39b94eab63abdb3691263c31165e437128c0dc8f41c43a356923bbb26e2"
    sha256 cellar: :any_skip_relocation, ventura:       "59023b0fbc67f76b2098e020a970ad9340f44744ce120c6e47aba38c8cd2e212"
    # Linux platforms (using Linux architecture naming)
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4f8cb344e0d64ee71ff2f8219d111c84e3f94738d1e20994ca5e18766806499"
    sha256 cellar: :any_skip_relocation, arm64_linux: "7fca2556c0320b4161065c8995ff6b2ae0c0dded6f7e1a9246254b93a82ffccb"
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
    
    system "echo 'Installing new GRPC Client version...'"
    
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
