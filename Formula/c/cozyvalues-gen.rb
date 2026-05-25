class CozyvaluesGen < Formula
  desc "Code generator for Go structs, CRDs, and JSON schemas from annotated YAML"
  homepage "https://github.com/cozystack/cozyvalues-gen"
  url "https://github.com/cozystack/cozyvalues-gen/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "c4ee78d8cacb7d931306fd2263110e9f093f7f7ac54a88bc0a8b3664863bbbd9"
  license "Apache-2.0"
  head "https://github.com/cozystack/cozyvalues-gen.git", branch: "main"

  depends_on "go" => [:build, :test]

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match "Version: #{version}", shell_output("#{bin}/cozyvalues-gen --version")

    (testpath/"values.yaml").write <<~YAML
      ## @param {string} name - Resource name
      ## @param {int} replicas - Number of replicas
      name: "demo"
      replicas: 1
    YAML

    system bin/"cozyvalues-gen",
           "--values", testpath/"values.yaml",
           "--schema", testpath/"schema.json",
           "--debug-go", testpath/"values.go"

    schema = (testpath/"schema.json").read
    assert_match "\"type\": \"string\"", schema
    assert_match "\"default\": \"demo\"", schema

    go_code = (testpath/"values.go").read
    assert_match "Name string `json:\"name\"`", go_code
    assert_match "Replicas int `json:\"replicas\"`", go_code
  end
end
