class KubeAws < Formula
  desc "Kubernetes on AWS"
  homepage "https://github.com/coreos/coreos-kubernetes/tree/master/multi-node/aws"
  url "https://github.com/coreos/coreos-kubernetes/archive/v0.8.1.tar.gz"
  sha256 "fe65c3fb72af7aa47dad07b8428eace077314edd3c129dba1fea5d3cccfaf094"
  head "https://github.com/coreos/coreos-kubernetes.git"

  depends_on "go" => :build

  def install
    executable="bin/kube-aws"
    ENV["GOPATH_VENDOR"]="#{Dir.pwd}/_gopath-vendor"
    ENV["GOPATH_KUBE_AWS"]="#{Dir.pwd}/_gopath-kube-aws"
    ENV["KUBE_AWS_DIR"]="#{ENV["GOPATH_KUBE_AWS"]}/src/github.com/coreos/coreos-kubernetes/multi-node/aws"
    ENV["OUTPUT_PATH"]=executable.to_s
    ENV["GOPATH"]="#{ENV["GOPATH_VENDOR"]}:#{ENV["GOPATH_KUBE_AWS"]}"

    Dir.chdir "#{Dir.pwd}/multi-node/aws/"

    rm_rf %w(ENV['GOPATH_VENDOR'] ENV['GOPATH_KUBE_AWS'])

    mkdir_p ENV["GOPATH_VENDOR"]
    mkdir_p File.dirname(ENV["KUBE_AWS_DIR"])

    ln "#{Dir.pwd}/vendor", "#{ENV["GOPATH_VENDOR"]}/src"
    ln Dir.pwd.to_s, (ENV["KUBE_AWS_DIR"]).to_s

    system "go", "generate", "./pkg/config"
    system "go build -ldflags '-X github.com/coreos/coreos-kubernetes/multi-node/aws/pkg/cluster.VERSION=#{version}' -a -tags netgo -installsuffix netgo -o '#{ENV["OUTPUT_PATH"]}' ./cmd/kube-aws"

    bin.install "#{Dir.pwd}/#{executable}" => "kube-aws"
  end

  test do
    output = shell_output("#{bin}/kube-aws version 2>&1")
    assert_match "kube-aws version #{version}", output
  end
end
