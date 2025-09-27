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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "09581ccf6479c90db7c57bbcb5bffd406d0ce2e70c287cb4395fe568c46bac97"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9801a524598029adf80e173f036aa5aa75c7b2a91533cdeb5e5a59433ec9b4e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25fb1d340365ab285ac9899676524a693216e12f891b0186eba64f7bc9b2d9c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "83fc8cf69235a2acc975901370f90546212ab3fefbe8f3cb4c61fff75ead4923"
    # macOS Intel platforms
    sha256 cellar: :any_skip_relocation, sonoma:        "5d990bcb25385f236a624022f87b65e2b5951925adb8818bfad5c7a566eea49a"
    sha256 cellar: :any_skip_relocation, ventura:       "1091b1b191e2248373cefd59039b7d090750be41a3d798f9ee592d85ace4e2ca"
    # Linux platforms (using Linux architecture naming)
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78433f638333f8a5be01b5b06b472984a6ecee6e4ffb153393bb6254ec2e93ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fcdd00c9e4c8d9af531b93783b8f7e5a117f81ac8d8b7e462dc54d071b590783"
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
