class Kenv < Formula
  desc "Environment file injector for Kubernetes resources"
  homepage "https://github.com/thisendout/kenv"
  url "https://github.com/thisendout/kenv/archive/v0.3.1.tar.gz"
  sha256 "c245583aee13cb0e1b6ec44e7d16fe83455fbca2657b73f49f1d7328b8594204"
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    bin_path = buildpath/"src/github.com/thisendout/kenv"
    bin_path.install Dir["*"]
    cd bin_path do
      system "go", "build", "-o", bin/"kenv", "."
    end
  end

  test do
    vars_file = "varstoinject.env"
    deployment_file = "deployment.yml"

    (testpath/vars_file).write <<~END
      key1=value1
      key2=value2
    END

    (testpath/deployment_file).write <<-EOS
    apiVersion: extensions/v1beta1
    kind: Deployment
    metadata:
      name: nginx
    spec:
      template:
        spec:
          containers:
          - name: nginx
            image: nginx:latest
    EOS

    require "open3"
    Open3.popen3(bin/"kenv", "-yaml", "-v", vars_file, deployment_file) do |_, stdout, _|
      require "yaml"
      parsed_yaml = YAML.safe_load stdout.read
      find = lambda do |result, key, expected|
        result["spec"]["template"]["spec"]["containers"].first["env"].find { |hash| hash[key] == expected }
      end

      assert find.call parsed_yaml, "name", "key1"
      assert find.call parsed_yaml, "name", "key2"
      assert find.call parsed_yaml, "value", "value1"
      assert find.call parsed_yaml, "value", "value2"
    end
  end
end
